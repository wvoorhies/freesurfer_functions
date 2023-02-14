
SUBJECT_LIST=/home/jesse/Desktop/neurocluster/Nora_PFCSulci/Projects/NORA_relmatch_funcNeuroAnat/scripts/fmri_cohort/relmatch_parlabels3/namelist_full.txt
SUBJECTS=$(cat $SUBJECT_LIST)

SUBJECTS_DIR=/home/jesse/Desktop/neurocluster/Nora_PFCSulci



#LABELS[1]='sfs_p'
#LABELS[2]='sfs_a'
#LABELS[3]='ifs'
#LABELS[4]='pmfs_p'
#LABELS[5]='pmfs_a'
#LABELS[6]='pmfs_i'
LABELS[1]='aipsJ'


for SUB_ID in $SUBJECTS; do

echo ${SUB_ID}

## create reg file to map between the two scans.

# rename the sphre file.


# old and new freesurfer dir 
OLD_DIR=Projects/NORA_relmatch_funcNeuroAnat/data/subjects_v7/sub-${SUB_ID}
NEW_DIR=Projects/NORA_relmatch_funcNeuroAnat/data/fc_seed232k_0mm-bp_wv/relmatch/sub-${SUB_ID}

cp -r ${SUBJECTS_DIR}/${NEW_DIR}/surf_32k ${SUBJECTS_DIR}/${NEW_DIR}/surf
cp ${SUBJECTS_DIR}/${NEW_DIR}/surf/fs/sphere.32k.L ${SUBJECTS_DIR}/${NEW_DIR}/surf/lh.sphere.reg
cp ${SUBJECTS_DIR}/${NEW_DIR}/surf/fs/sphere.32k.R ${SUBJECTS_DIR}/${NEW_DIR}/surf/rh.sphere.reg


for LABEL in ${LABELS[@]}; do
      
      mri_label2label --srcsubject ${OLD_DIR} --srclabel ${SUBJECTS_DIR}/${OLD_DIR}/label/lh.${LABEL}.label --trgsubject  ${NEW_DIR} \
      	--trglabel ${SUBJECTS_DIR}/${NEW_DIR}/lh.${LABEL}.label --regmethod surface --hemi lh


      mri_label2label --srcsubject ${OLD_DIR} --srclabel ${SUBJECTS_DIR}/${OLD_DIR}/label/rh.${LABEL}.label --trgsubject  ${NEW_DIR} \
      	--trglabel${SUBJECTS_DIR}/${NEW_DIR}/rh.${LABEL}.label --regmethod surface --hemi rh
      
 
    done
 done
