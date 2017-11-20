FROM centos

RUN yum -y install centos-release-scl epel-release && \
    yum -y install cloc cmake cmake3 cppcheck devtoolset-6 doxygen findutils git graphviz lcov rh-python35 vim-common \
    yum -y autoremove && \
    yum clean all

RUN scl enable rh-python35 -- pip install conan==0.28.0 coverage==4.4.1 flake8==3.4.1 gcovr==3.3 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    scl enable rh-python35 conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/ess-dmsc/utils.git && \
    cd utils && \
    git checkout 98b81cf00f80ceb8383eb4dc6abb27669959e11b && \
    scl enable devtoolset-6 -- make install

RUN adduser jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins

CMD ["/usr/bin/scl", "enable", "rh-python35", "devtoolset-6", "/bin/bash"]
