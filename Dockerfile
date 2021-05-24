FROM expertsp/racp:1.1

ENV EQVDIR=/tmp/SOFTWARE/
ENV COS="10.243.12.208"
RUN mkdir -p $EQVDIR
VOLUME $PWD: $EQVDIR

COPY $PWD/SinglePC/ils*.setup $EQVDIR
COPY $PWD/TestEnv/ils*.setup $EQVDIR

WORKDIR $EQVDIR

#RUN yes | bash ils.ILS*.setup
RUN  bash ilstest*.setup -i

RUN printf "$COS cos1 cos2 cos3 cos4" >> /etc/hosts


EXPOSE 80
EXPOSE 3077

ENTRYPOINT ["/bin/bash" ]




