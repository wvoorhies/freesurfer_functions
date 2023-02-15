# generate labels for each lobe 
SUBJECT_LIST=/home/weiner/Nora_PFCSulci/Projects/NORA_relmatch_funcNeuroAnat/scripts/fmri_cohort/relmatch/namelist_cs-labeled.txt

SUBJECTS=$(cat $SUBJECT_LIST)


SUBJECTS_DIR=/home/weiner/Nora_PFCSulci/Projects/NORA_relmatch_funcNeuroAnat/data/subjects_v7

#mri_annotation2label --subject fsaverage_prob --hemi lh --lobesStrict lh.lobesStrict.annot

#mri_annotation2label --subject fsaverage_prob --hemi rh --lobesStrict rh.lobesStrict.annot

#mri_annotation2label --subject fsaverage_prob --hemi lh --annotation lobesStrict --outdir ${SUBJECTS_DIR}/fsaverage_prob/label

#mri_annotation2label --subject fsaverage_prob --hemi rh --annotation lobesStrict --outdir ${SUBJECTS_DIR}/fsaverage_prob/label


for SUB in $SUBJECTS ; do

mri_annotation2label --subject sub-${SUB} --hemi lh --lobesStrict lh.lobesStrict.annot

mri_annotation2label --subject sub-${SUB} --hemi rh --lobesStrict rh.lobesStrict.annot

mri_annotation2label --subject sub-${SUB} --hemi lh --annotation lobesStrict --outdir ${SUBJECTS_DIR}/sub-${SUB}/label

mri_annotation2label --subject sub-${SUB} --hemi rh --annotation lobesStrict --outdir ${SUBJECTS_DIR}/sub-${SUB}/label
done
