import os
import subprocess
import toml
import time

# Load the config file
config = toml.load('config.toml')

def run_command(command):
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = process.communicate()
    return out, err

def check_table_entry(config_path):
    with open(config_path, 'r') as file:
        return "Table =" in file.read()

while True:
    for chain in config['chain']:
        prev_interface = None

        for interface_path in chain['interfaces']:
            interface_name = os.path.basename(interface_path).split('.')[0]

            # Check if "Table =" exists in config, if not, add it
            if not check_table_entry(interface_path):
                with open(interface_path, 'a') as file:
                    file.write("\nTable = 100")

            # If there's a previous interface, configure routing through current interface
            if prev_interface:
                run_command(f"ip rule add from {prev_interface} table 100")
                run_command(f"ip rule add to {prev_interface} table 100")
                run_command(f"ip route add default via {interface_name} dev {interface_name} table 100")

            # Start this interface
            run_command(f"wg-quick up {interface_path}")

            # Update prev_interface for the next loop iteration
            prev_interface = interface_name

        # Configure iptables for NAT and forwarding for the final interface in the chain
        final_interface = os.path.basename(chain['interfaces'][-1]).split('.')[0]
        run_command(f"iptables -t nat -A POSTROUTING -o {chain['wan_interface']} -j MASQUERADE")
        run_command(f"iptables -A FORWARD -i {final_interface} -o {chain['wan_interface']} -j ACCEPT")
        run_command(f"iptables -A FORWARD -i {chain['wan_interface']} -o {final_interface} -j ACCEPT")

    # Enable IP forwarding
    if config['system']['enable_ip_forwarding']:
        run_command("sysctl net.ipv4.ip_forward=1")

    time.sleep(60)  # Wait for 1 minute before checking again

