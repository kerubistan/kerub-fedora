
clean:
	rpmdev-wipetree
	rm -f kerub.spec

all: rpms

kerub.spec:
	cat kerub.spec.in | sed -e 's/BUILD/$(BUILD_ID)/g' > kerub.spec

rpms: sources
	rpmbuild -ba kerub.spec

rpmdirs:
	rpmdev-setuptree

sources: rpmdirs 
	spectool -g -R kerub.spec
	#TODO: this looks like I am doing half of spectool's job
	cp kerub.xml `rpm --eval "%{_sourcedir}"`
	cp kerub.pp `rpm --eval "%{_sourcedir}"`
	cp kerub.mod `rpm --eval "%{_sourcedir}"`
	cp keystore.jks `rpm --eval "%{_sourcedir}"`
	cp shiro.ini `rpm --eval "%{_sourcedir}"`
	cp logback.xml `rpm --eval "%{_sourcedir}"`
	cp kerub.properties.local `rpm --eval "%{_sourcedir}"`
	cp kerub.properties.cluster `rpm --eval "%{_sourcedir}"`

upload:
	curl -uk0zka:$(APIKEY) -X POST --data '{"name":"$(BUILD_ID)","desc":"Kerub IaaS build $(BUILD_ID)"}' https://api.bintray.com/packages/k0zka/kerub-fedora/kerub/versions -v -H 'Content-Type: application/json'
	curl -v -T $(HOME)/rpmbuild/RPMS/noarch/kerub-master-$(BUILD_ID).noarch.rpm -uk0zka:$(APIKEY) https://api.bintray.com/content/k0zka/kerub-fedora/kerub/$(BUILD_ID)/kerub-master-$(BUILD_ID).rpm?publish=1

