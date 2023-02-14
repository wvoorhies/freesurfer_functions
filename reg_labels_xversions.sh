
## 
# Accurately map labels between different iterations of reconall
# This has only been tested on 2 reconstructions that come from the same subject, same T1 but were just reconstructed with different versions of freesurfer. 
# In the above scenario it improves label registration above label2label and using a longitudinal scan. 
# Use freesurfer V7
# See https://www.mail-archive.com/freesurfer@nmr.mgh.harvard.edu/msg71296.html for more details
##

SUBJECT_LIST=/home/weiner/Nora_PFCSulci/Projects/NORA_relmatch_funcNeuroAnat/subjectLists/missing.txt
SUBJECTS=$(cat $SUBJECT_LIST)

SUBJECTS_DIR=/home/weiner/Nora_PFCSulci

LABEL_LIST=/home/weiner/Nora_PFCSulci/Projects/NORA_relmatch_funcNeuroAnat/LPC_label_list.txt
LABELS=$(cat $LABEL_LIST)

cd ${SUBJECTS_DIR}

for SUB_ID in $SUBJECTS; do

echo ${SUB_ID}

## create reg file to map between the two scans.


# old and new freesurfer dir 
OLD_DIR=${SUBJECTS_DIR}/subjects/${SUB_ID}
NEW_DIR=${SUBJECTS_DIR}/Projects/NORA_relmatch_funcNeuroAnat/data/subjects_v7/sub-${SUB_ID}

# create registration

#bbregister --mov ${OLD_DIR}/mri/nu.mgz --s ${NEW_DIR} --t1 --reg reg_${SUB_ID}.lta

# map old surface into new surface space

#mris_apply_reg --lta ${OLD_DIR}/surf/lh.white ${SUBJECTS_DIR}/reg_${SUB_ID}.lta ${NEW_DIR}/surf/lh.white.old
#mris_apply_reg --lta ${OLD_DIR}/surf/rh.white ${SUBJECTS_DIR}/reg_${SUB_ID}.lta ${NEW_DIR}/surf/rh.white.old


# map old labels to new reconstruction

for label in $LABELS; do
chmod 775 ${OLD_DIR}/label/rh.${label}.label
chmod 775 ${OLD_DIR}/label/lh.${label}.label

mris_apply_reg --src-label ${OLD_DIR}/label/lh.${label}.label --streg ${NEW_DIR}/surf/lh.white.old ${NEW_DIR}/surf/lh.white --o ${NEW_DIR}/label/lh.${label}.label

mris_apply_reg --src-label ${OLD_DIR}/label/rh.${label}.label --streg ${NEW_DIR}/surf/rh.white.old ${NEW_DIR}/surf/rh.white --o ${NEW_DIR}/label/rh.${label}.label

done
done
