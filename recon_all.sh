
SUBJECTS_DIR=/home/weiner/Nora_PFCSulci/Projects/NORA_relmatch_funcNeuroAnat/data/subjects_v7

# grid engine

sub=${SGE_TASK}

rm -r ${SUBJECTS_DIR}/sub-${sub}
# run recon-all 
recon-all -i ${SUBJECTS_DIR}/${sub}.nii -subjid sub-${sub} -all 