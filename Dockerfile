FROM centos

RUN yum -y install centos-release-scl epel-release && \
    yum -y install cloc cmake cmake3 cppcheck devtoolset-6 doxygen findutils git graphviz lcov rh-python35 vim-common \
    yum -y autoremove && \
    yum clean all

RUN scl enable rh-python35 -- pip install conan==0.26.1 coverage==4.4.1 flake8==3.4.1 gcovr==3.3 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    scl enable rh-python35 conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/

RUN git clone https://github.com/ess-dmsc/utils.git && \
    cd utils && \
    git checkout de71215c3ee781b2707c096cb7516b34fc239593 && \
    scl enable devtoolset-6 -- make install

RUN adduser jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins

CMD ["/usr/bin/scl", "enable", "rh-python35", "devtoolset-6", "/bin/bash"]
