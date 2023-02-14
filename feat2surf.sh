# ## bash

# ####################################################################################### 
# # Register FSL output to freesurfer surface and perform second level GLM on the surface
# ########################################################################################

SUBJECTS_DIR=/Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/subjects
#SUBJECTS_LIST=subs.txt
SUBJECTS_LIST=subs_list2.txt
ctab=/Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/ColorMapLUT.txt


der_dir=/Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives
feat_dir=${der_dir}/preprocessing/native

for s in `cat $SUBJECTS_LIST`
do

#### set session and subject ID ####
session=${s: -1}
sub=${s: 1:3}
subj='sub-'${sub}
ses='ses-'${session}

# mkdir ${der_dir}/2nd_level/${subj}_${ses}

# ### Register feat directory from each run to the subject surface ####

 echo "generating registration matrix"
 for r in {1..3}
 do
 	run=run-0${r}
 	reg-feat2anat --feat ${feat_dir}/${subj}_${ses}_${run}.feat \
 --subject $subj  --overwrite-exf2std 

 done


#### make a copy of lh.sphere.reg called lh.$sub.sphere.reg (fs looks for this because it was built to register to the average)
cp ../data/subjects/${subj}/surf/lh.sphere.reg ../data/subjects/${subj}/surf/lh.${subj}.sphere.reg
cp ../data/subjects/${subj}/surf/rh.sphere.reg ../data/subjects/${subj}/surf/rh.${subj}.sphere.reg
### resample all copes to a common surface ####
echo "resampling copes to a common surface"

for num in {1..3}
do
 mris_preproc --target ${subj} --hemi lh \
 --out ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/lh.cope${num}.mgh \
 --iv ${feat_dir}/${subj}_${ses}_run-01.feat/stats/cope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-01.feat/reg/freesurfer/anat2exf.register.dat \
 --iv ${feat_dir}/${subj}_${ses}_run-02.feat/stats/cope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-02.feat/reg/freesurfer/anat2exf.register.dat \
 --iv ${feat_dir}/${subj}_${ses}_run-03.feat/stats/cope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-03.feat/reg/freesurfer/anat2exf.register.dat

  mris_preproc --target ${subj} --hemi rh  \
   --out ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/rh.cope${num}.mgh \
  --iv ${feat_dir}/${subj}_${ses}_run-01.feat/stats/cope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-01.feat/reg/freesurfer/anat2exf.register.dat \
    --iv ${feat_dir}/${subj}_${ses}_run-02.feat/stats/cope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-02.feat/reg/freesurfer/anat2exf.register.dat \
     --iv ${feat_dir}/${subj}_${ses}_run-03.feat/stats/cope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-03.feat/reg/freesurfer/anat2exf.register.dat

# #### resample all varcopes to a common surface ####
 mris_preproc --target ${subj} --hemi lh  \
  --out ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/lh.varcope${num}.mgh \
  --iv ${feat_dir}/${subj}_${ses}_run-01.feat/stats/varcope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-01.feat/reg/freesurfer/anat2exf.register.dat \
    --iv ${feat_dir}/${subj}_${ses}_run-02.feat/stats/varcope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-02.feat/reg/freesurfer/anat2exf.register.dat \
     --iv ${feat_dir}/${subj}_${ses}_run-03.feat/stats/varcope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-03.feat/reg/freesurfer/anat2exf.register.dat

  mris_preproc --target ${subj} --hemi rh  \
  --out ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/rh.varcope${num}.mgh \
  --iv ${feat_dir}/${subj}_${ses}_run-01.feat/stats/varcope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-01.feat/reg/freesurfer/anat2exf.register.dat \
    --iv ${feat_dir}/${subj}_${ses}_run-02.feat/stats/varcope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-02.feat/reg/freesurfer/anat2exf.register.dat \
     --iv ${feat_dir}/${subj}_${ses}_run-03.feat/stats/varcope${num}.nii.gz ${feat_dir}/${subj}_${ses}_run-03.feat/reg/freesurfer/anat2exf.register.dat

# ### Surface based group analysis #### 

 echo "running fixed effects"
 ## 1. across runs (fixed effects)
 mri_glmfit --y ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/lh.cope${num}.mgh --yffxvar ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/lh.varcope${num}.mgh --ffxdof 133 \
            --osgm --glmdir ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/lh.osgm.ffx --surf ${subj} lh \
            --label $SUBJECTS_DIR/${subj}/label/lh.cortex.label

 mri_glmfit --y ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/rh.cope${num}.mgh --yffxvar ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/rh.varcope${num}.mgh --ffxdof 133 \
            --osgm --glmdir ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/rh.osgm.ffx --surf ${subj} rh \
            --label $SUBJECTS_DIR/${subj}/label/rh.cortex.label


# ### use pmfs i labels  as mask 
 mri_glmfit --y ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/lh.cope${num}.mgh --yffxvar ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/lh.varcope${num}.mgh --ffxdof 133 \
            --osgm --glmdir ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/lh.osgm_pmfs.ffx --surf ${subj} lh \
            --label $SUBJECTS_DIR/${subj}/label/lh.pmfs_i.label

 mri_glmfit --y ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/rh.cope${num}.mgh --yffxvar ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/rh.varcope${num}.mgh --ffxdof 133 \
            --osgm --glmdir ${der_dir}/2nd_level/native/${subj}_${ses}/xrun_cope${num}/rh.osgm_pmfs.ffx --surf ${subj} rh \
            --label $SUBJECTS_DIR/${subj}/label/rh.pmfs_i.label
# ## 2. across the group (random effects)
# # a. all copes 
# # concatinate all images 
# #cp ../data/BIDS/${subj}/${ses}/func/xrun/lh.cope1.mgh ../data/BIDS/group_GLM/lh.cope1_${subj}.mgh
# #cp ../data/BIDS/${subj}/${ses}/func/xrun/rh.cope1.mgh ../data/BIDS/group_GLM/rh.cope1_${subj}.mgh
# # b. 


done
# done
#### extract stats from labels ####


mri_segstats --annot ${subj} rh DLPFC_sulclabels  --i /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope1/rh.cope1.mgh --sum /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope1/rh_dlpfcsulc_func.dat  --ctab /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/ColorMapLUT.txt 
mri_segstats --annot ${subj} lh DLPFC_sulclabels  --i /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope1/lh.cope1.mgh --sum /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope1/lh_dlpfcsulc_func.dat  --ctab /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/ColorMapLUT.txt 

mri_segstats --annot ${subj} rh DLPFC_sulclabels  --i /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope2/rh.cope2.mgh --sum /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope2/rh_dlpfcsulc_func.dat  --ctab /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/ColorMapLUT.txt 
mri_segstats --annot ${subj} lh DLPFC_sulclabels  --i /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope2/lh.cope2.mgh --sum /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope2/lh_dlpfcsulc_func.dat  --ctab /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/ColorMapLUT.txt 

mri_segstats --annot ${subj} rh DLPFC_sulclabels  --i /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope3/rh.cope3.mgh --sum /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope3/rh_dlpfcsulc_func.dat  --ctab /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/ColorMapLUT.txt 
mri_segstats --annot ${subj} lh DLPFC_sulclabels  --i /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope3/lh.cope3.mgh --sum /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/2nd_level/native/${subj}_${ses}/xrun_cope3/lh_dlpfcsulc_func.dat  --ctab /Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/ColorMapLUT.txt 

done


