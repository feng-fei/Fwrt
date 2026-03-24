# Update for LuCI and Firewall Configuration

# Ensure uhttpd binds to all interfaces
config uhttpd main
    option listen_ip '0.0.0.0'

# Enable LuCI service
config service luci
    option enabled '1'

# Open HTTP port in firewall
config rule
    option src 'wan'
    option target 'ACCEPT'
    option proto 'tcp'
    option dest_port '80'