#!/bin/bash

# stop tmux server -> gracefully ends all sessions
echo "--> Stopping tmux server -> exiting all sessions gracefully..."
tmux kill-server
