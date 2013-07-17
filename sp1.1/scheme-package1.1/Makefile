CLASSES=*.class scheme/kernel/*.class  scheme/extensions/*.class \
         scheme/primitives/*.class scheme/java/*.class

all : j lib jar doc

j :
	javac -deprecation -verbose *.java
	javac -deprecation -verbose scheme/java/*.java

lib:
	java ScmLoader library/library.scm library/java-headers.scm

jar:
	echo "Manifest-Version: 1.0" > Manifest.mf
	echo "Main-Class: ScmInterpreter" >> Manifest.mf
	jar cmfv Manifest.mf scm.jar $(CLASSES)

doc :
	javadoc -d scheme/docs scheme.kernel scheme.primitives scheme.extensions \
                   scheme.java

wc :
	wc scheme/kernel/*.java scheme/primitives/*.java scheme/extensions/*.java \
           scheme/java/*.java

clean :
	rm -f $(CLASSES) *~ scheme/kernel/*~ scheme/extensions/*~ \
           scheme/primitives/*~ scheme/java/*~ scheme/docs/*.html \
           scheme/docs/scheme/kernel/*.html scheme/docs/scheme/extensions/*.html \
           scheme/docs/scheme/java/*.html scheme/docs/scheme/primitives/*.html \
           library/*~ library/object/*~ library/object/java/*~ library/object/gui/*~ \
           library/object/java/generated/*.scm Manifest.mf scm.jar
