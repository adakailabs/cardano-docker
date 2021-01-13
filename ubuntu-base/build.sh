docker login 
docker build -t adakailabs/ubuntu-base:latest .
docker push adakailabs/ubuntu-base:latest
docker run -it adakailabs/ubuntu-base:latest source /etc/profile && bash
