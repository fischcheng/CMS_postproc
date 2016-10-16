## Post-processing CMS ascii output

#### Backgrounds:
The [Connectivity Modeling System (CMS)](https://www.researchgate.net/profile/Claire_Paris/publication/250917334_Connectivity_Modeling_System_A_probabilistic_modeling_tool_for_the_multi-scale_tracking_of_biotic_and_abiotic_variability_in_the_ocean/links/54315f740cf29bbc1278979e.pdf) has been developed to study complex larval migrations and give probability estimates of population connectivity. The CMS can also passively track virtual particles that passively advected by the velocity fields. 

Since 2014, I have been using CMS to quantify Agulhas Leakage, by seeding particles in the Agulhas Current jet and track the number of particles that end up on the other side of the GoodHope line and the timing of such crossings. By summing up the crossing particles at each time step, we create a time series of Agulhas leakage. More details can be found in my recent [paper](http://journals.ametsoc.org/doi/abs/10.1175/JCLI-D-15-0568.1). 

#### Motivations
As the coupled model keeps generating more outputs, running CMS like before becomes less practical. The CMS was not designed to track particles at such scale for such a long period of times (multiple decades). Also, I ran into some issues when I tried submitting CMS jobs to the UM cluster -- a continuous job cannot complete within the wall time and memory limits. So, I came up with a walk-around to divide the multi-decade-long job into several smaller chunks, ensuring that such jobs can complete successfully. Moreover, by doing that, I can easily extend the leakage time-series without repeating the previous years. 

One day, folks from Center for Computational Science (CCS) told me that I was suspended from submitting more CMS jobs because such jobs drained the system memory and significantly dragged down the performance of the cluster. Some staffs helped me to test run CMS on an isolated filesystem, and we eventually identified that the vast part of memory usage was caused by outputting as NetCDF files. So they advised all CMS users on the cluster to set the output format to ASCII. 

Changing output to ASCII reduces the required time for a 5-year chunk tracking 600 thousand particles from 12hrs to less than 30mins. However, that also renders my old post-processing scripts useless. This repo documented some of the changes I made. 


#### What can these scripts do?
* `gen_hrc07_release_chunks.py` and `multiple_gen.py` are used to generate releasefiles and their corresponding volume_tag files. `multiple_gen.py` calls `gen_hrc07_release_chunks.py` as a function to generate releasefiles in five-year chunks.
* `changeending.py` can add `.txt` to the `traj_file_xx` in the `expt_name/output` folder. Alternatively, one can modify the source code of CMS by adding `//".txt"` to `output.f90` line 55-57. This change allows the matlab function tabularTextDatastore (available after 2016a) to detect these ascii files. 
* `traj_proc_update.m` is the main program, calling two functions `cms_ascii_postproc` and `dailyload_core_voltag`. `proc_sub` is a sample LSF job submit script.
* `jul2greg.m` is used in `cms_ascii_postproc` to change the original releasedate to gregorian days (from internet).
* `chunk_traj_proc.py` copies, renames and edits `traj_proc_update.m` and `proc_sub` for several chunks at once. 




