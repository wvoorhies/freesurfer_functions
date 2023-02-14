# command to run Freesurfer mris_anatomicals to get morphological metrics for surface based labels. 
# output: individual text files saved to "label_stats_dir". Recommended to run morpholical_metrics.py to concatenate and get additional labels. 
# reqs: recon-all run for all participants of in interest. labels in the label directory. 

count=1
CHIMP_LIST=/home/weiner/NH_Primates/projects/LPFC/other_subs.txt # a text file listing all the participants
SUBJECTS_DIR=/home/weiner/NH_Primates/chimp_data
LABEL_LIST=/home/weiner/NH_Primates/projects/LPFC/painfs.txt

for SUB in $(cat $CHIMP_LIST)
do
echo $SUB #reading out subject label. 

#set dir to label files
label_dir=${SUBJECTS_DIR}/${SUB}/label

#make a label stats dir
label_stats_dir=${SUBJECTS_DIR}/${SUB}/label/label_stats
rm -r $label_stats_dir
mkdir $label_stats_dir

#for each label in the left hemisphere run mris_anatomicals command
for label in $(cat $LABEL_LIST)
do


  mris_anatomical_stats -b -l lh.${label}.label ${SUB} lh > ${label_stats_dir}/lh.${label}.stats.txt

# do same for right label


  mris_anatomical_stats -b -l rh.${label}.label ${SUB} rh > ${label_stats_dir}/rh.${label}.stats.txt
done
done


