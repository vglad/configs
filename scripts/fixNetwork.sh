echo "Restarting docker..."
systemctl restart docker.service &&\
    printf "Done\n" || printf "Failed to restart docker\n"

echo "Restarting NetworkManager..."
systemctl restart NetworkManager &&\
    printf "Done\n" || printf "Failed to restart NetworkManager\n"
