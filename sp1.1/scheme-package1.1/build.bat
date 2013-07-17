@echo OFF

echo Java Compilation ...
javac *.java
javac scheme\java\*.java
echo ... Java compilation done.

echo Library creation ...
java ScmLoader library/library.scm library/java-headers.scm
echo ... Library done.

echo Making scm.jar ...
echo Manifest-Version: 1.0 > Manifest.mf
echo Main-Class: ScmInterpreter >> Manifest.mf
jar cmf Manifest.mf scm.jar *.class scheme\kernel\*.class  scheme\extensions\*.class scheme\primitives\*.class scheme\java\*.class
echo ... scm.jar done.

echo Making documentation ...
javadoc -d scheme\docs scheme.kernel scheme.primitives scheme.extensions scheme.java
echo ... documentation done.
