FROM centos:7

RUN yum -y install centos-release-scl epel-release && \
    yum -y install bzip2 clang-analyzer cloc cmake cmake3 cppcheck devtoolset-6 doxygen findutils git graphviz lcov mpich-3.2-devel rh-python35 vim-common \
    yum -y autoremove && \
    yum clean all

RUN scl enable rh-python35 -- pip install conan==1.0.2 coverage==4.4.2 flake8==3.5.0 gcovr==3.3 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    scl enable rh-python35 conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/ess-dmsc/utils.git && \
    cd utils && \
    git checkout 3f89fad6e801471baabee446ba4d327e54642b32 && \
    scl enable devtoolset-6 -- make install

RUN adduser jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins

RUN scl enable rh-python35 -- conan install cmake_installer/3.10.0@conan/stable

CMD ["/usr/bin/scl", "enable", "rh-python35", "devtoolset-6", "/bin/bash"]
