FROM rockylinux/rockylinux:9-ubi AS builder
# registry.access.redhat.com/ubi9: CodeReady Builder does not provide swig on aarch64 !?!

RUN --mount=type=cache,target=/sources \
    dnf install 'dnf-command(config-manager)' --assumeyes && \
    dnf config-manager --enable crb --assumeyes && \
	dnf config-manager --enable highavailability --assumeyes && \
    dnf module enable swig --assumeyes && \
    dnf install --assumeyes rpm-build autoconf-archive automake gcc-c++ pcre2-devel m4 swig python python-devel git libcap-devel zlib-devel wget docbook-dtds docbook-style-xsl glib2-devel libqb-devel libxslt perl && \
    cd /root && \
    groupadd mock && adduser mockbuild && \
    curl -LO https://download.fedoraproject.org/pub/fedora/linux/development/rawhide/Everything/source/tree/Packages/r/resource-agents-4.16.0-1.fc42.src.rpm && \
    rpm -iv *src.rpm && \
	rpmbuild -ba --define='_unpackaged_files_terminate_build 0' ~/rpmbuild/SPECS/resource-agents.spec
# something is wrong with the ldirectord startup scripts but we don't care
	