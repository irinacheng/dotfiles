with import <nixpkgs> {};

let
  spark_no_mesos = spark.override { mesosSupport = false; };
  scikitlearn_no_test = python3Packages.scikitlearn.overridePythonAttrs (oldAttrs: { checkPhase = "true"; });
in
stdenv.mkDerivation rec {
  name = "pyspark";
  env = buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [
    spark_no_mesos
    mtr
    graphviz-nox

    #(python.buildEnv.override {
    #    ignoreCollisions = true;
    #    extraLibs = with pythonPackages; [
    #        ipython
    #        notebook
    #        pandas
    #        matplotlib
    #        seaborn
    #        patsy
    #    ];
    #})
    (python3.buildEnv.override {
        ignoreCollisions = true;
        extraLibs = with python3Packages; [
            #ipython
            #notebook
            pandas
            matplotlib
	    seaborn
	    patsy
 	    statsmodels
	    #jupyter_console
	    scipy
	    numpy
	    graphviz
	    #pydotplus
            scikitlearn_no_test
            virtualenv
        ];
    })


  ];
  shellHook = ''
    export PYSPARK_DRIVER_PYTHON=$(which jupyter-notebook)
    source $HOME/venv/bin/activate
  '';
}
