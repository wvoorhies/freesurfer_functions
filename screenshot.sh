# bash 

# Take screenshots of freesurfer code. 
# use freeview -help to see all option
# REQS: freesurfer 7.0 or higher

### load fs overlay and take screenshots
CHIMP_LIST=/home/weiner/NH_Primates/projects/LPFC/chimp_list.txt # a text file listing all the participants
SUBJECTS_DIR=/home/weiner/NH_Primates/chimp_data # Freesurfer subjects directory



for SUB in `cat $CHIMP_LIST`
do


freeview -f ${SUBJECTS_DIR}/${SUB}/surf/lh.inflated:curvature_method='binary':annot=${SUBJECTS_DIR}/${SUB}/label/lh.DLPFC_manual.annot -viewport 3D -view lateral -ss /home/weiner/catehath/screenshots/${SUB}_lh.png
freeview -f ${SUBJECTS_DIR}/${SUB}/surf/rh.inflated:curvature_method='binary':annot=${SUBJECTS_DIR}/${SUB}/label/rh.DLPFC_manual.annot -viewport 3D -view lateral -ss /home/weiner/catehath/screenshots/${SUB}_rh.png
done