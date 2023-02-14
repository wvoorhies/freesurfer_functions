#!/bin/sh

#### Run recon-all on the grid engine via {SGE} ####

#################################################################
# *** note this can take many hours depending on  the size of your data. ***
# check log and output files in working dir for progress. 

# ---- requirements ------  

# 1. A shared directory in /home/weiner/: Email support-cirl@berkeley.edu 
# 2.run setup_utils/setup_dir.py to generate a directory structure. 
# 3. a  subjects list as a text file in Shared_dir/subjects_list/
	# eg.
		# subjects_list.txt 
			# n002
			# n003
			# n005
# 4. subject structural scans as .nii in /shared_dir/subjects/ 

# ----- Usage --------

# submit -s <path to shell script> -f <subjects_list.txt>

# (for more info on SGE jobs: https://www.neuro.berkeley.edu/resources/software/sge/scripting.html

# ----- Output --------

# A freesurfer directory with freesurfer cortical reconstructions and associated surfaces for each each subject
# A freesurfer average surface
# log files (output/errors) in working directory 

#######################################################################

# define freesurfer subjects directory to be shared_folder/subjects

SUBJECTS_DIR=subjects  

# grid engine

sub=${SGE_TASK}

# run recon-all 
recon-all -i ${SUBJECTS_DIR}/${sub}.nii -subjid ${sub} -all -localgi
