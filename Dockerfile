FROM expertsp/racp:1.1

ENV EQVDIR=/tmp/SOFTWARE/
ENV COS="10.243.12.208"
ENV RUNFILE="/tmp/SOFTWARE/run.sh"
RUN mkdir -p $EQVDIR
VOLUME $PWD: $EQVDIR

COPY $PWD/SinglePC/ils*.setup $EQVDIR
COPY $PWD/TestEnv/ils*.setup $EQVDIR

WORKDIR $EQVDIR

SHELL ["/bin/bash", "-c"]

#RUN yes | bash ils.ILS*.setup
RUN  bash ilstest*.setup -i





RUN echo $' #!/bin/bash \n\
printf "$COS cos1 cos2 cos3 cos4" >> /etc/hosts \n\
ARGS=$(date) \n\
if test -f /opt/mt/www/bin/check_integrity.php; \n\
then \n\
	php /opt/mt/www/bin/check_integrity.php 2>/dev/null \n\
	sleep 3 \n\
	cd /var/persistent/mt/ || exit 1 \n\
	sed "s/info>/info>$ARGS/" /var/persistent/mt/current.integrity > approved.integrity \n\
	echo "Succesfull approve" \n\
else \n\
		echo "Eqv not found or not install" \n\
		exit 1 \n\
fi \n\
screen -dmS ilst_Test /opt/ilstest/startTIP 1 $COS  \n\
sleep 3 \n\
./run 1 \n\
\n' > /tmp/SOFTWARE/config.sh

#RUN chmod +x $RUNFILE

WORKDIR /opt/ils/bin/




EXPOSE 80
EXPOSE 3077

ENTRYPOINT ["/bin/bash" ]




