FROM gitpod/workspace-full

RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk install java sdk install java 8.0.181-oracle && sdk use java java 8.0.181-oracle"