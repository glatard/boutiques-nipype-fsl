# boutiques-nipype-fsl

A repository of [Boutiques](https://github.com/boutiques) descriptors for [Nipype](https://github.com/nipy/nipype) interfaces to [FSL](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/) tools. Descriptors were generated semi-automatically using [nipype2boutiques](https://github.com/nipy/nipype/blob/master/nipype/utils/nipype2boutiques.py).

* `bin`: 
  * `export_module.sh`: the script used to export the Nipype interfaces. Command line used:
    `./export_module.sh nipype.interfaces.fsl glatard/nipype_fsl ignore.csv skip.txt`
  * `skip.txt`: the list of FSL interfaces **not** exported, with explanations.
  * `ignore.csv`: FSL interface inputs ignored in the creation of output path templates.

* `tools`: the resulting Boutiques descriptors.