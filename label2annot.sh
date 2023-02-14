
# transform a list of labels into a single annotation file. 
# REQS: a color table (see cannonical freesurfer colormap for format.) that assigns a color to each label in your list. 

CHIMP_LIST=/home/weiner/NH_Primates/projects/LPFC/chimp_list.txt # a text file listing all the participants
SUBJECTS_DIR=/home/weiner/NH_Primates/chimp_data
color_table=/home/weiner/NH_Primates/projects/LPFC/colorMapLUT.txt

for SUB in $(cat $CHIMP_LIST)
do
echo $SUB #reading out subject label. 
#rm ${SUBJECTS_DIR}/c26/label/lh.DLPFC_manual.annot 
#rm ${SUBJECTS_DIR}/c26/label/rh.DLPFC_manual.annot 

mris_label2annot --s $SUB --h lh \
  --ctab $color_table --a DLPFC_manual \
  --l lh.ifs.label \
  --l lh.sfs-a.label \
  --l lh.sfs-p.label \
  --l lh.pmfs-i.label \
  --l lh.pmfs-p.label \
  --l lh.pmfs-a.label \
  --l lh.pimfs.label

done