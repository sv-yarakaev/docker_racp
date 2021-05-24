FROM expertsp/racp:1.1

ENV EQVDIR=/tmp/SOFTWARE/
ENV COS="10.243.12.208"
ENV CONFILE="/root/conf.sh"
ENV RUNFILE="/root/run.sh"
RUN mkdir -p $EQVDIR
VOLUME $PWD: $EQVDIR

COPY $PWD/SinglePC/ils*.setup $EQVDIR
COPY $PWD/TestEnv/ils*.setup $EQVDIR

WORKDIR $EQVDIR


RUN yes | bash ils.ILS*.setup
RUN  bash ilstest*.setup -i



RUN touch $RUNFILE && chmod +x $RUNFILE
RUN touch $CONFILE && chmod +x $CONFILE

RUN echo $' #!/bin/bash \n\
printf "$COS cos1 cos2 cos3 cos4" >> /etc/hosts \n\
printf "127.0.0.1 spu1 localhost.localdomain localhost" >> /etc/hosts \n\
sed -i "s/Listen 80/Listen 0.0.0.0:80/g" /etc/httpd/conf/httpd.conf \n\
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
\n' >> $CONFILE

RUN $CONFILE


WORKDIR /opt/ils/bin/

RUN $'/bin/bash \n\
service httpd start \n\
sleep 1 \n\
service evlog start \n\
sleep 1 \n\
service spread start \n\
sleep 1 \n\
nohup /opt/ilstest/startTIP 1 $COS & \n\
sleep 1 \n\
nohup ./run 1 & \n\
\n' > $RUNFILE




EXPOSE 80:80
EXPOSE 3077

ENTRYPOINT [ "/bin/bash" ]

