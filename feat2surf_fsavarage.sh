## bash

####################################################################################### 
# Register FSL output to freesurfer surface and perform second level GLM on the surface
########################################################################################

SUBJECTS_DIR=../data/subjects
SUBJECTS_LIST=../subjectLists/subs_list2.txt

for s in `cat $SUBJECTS_LIST`
do

#### set session and subject ID ####
session=${s: -1}
sub=${s: 1:3}
subj='sub-'${sub}
ses='ses-'${session}

#### Register feat directory from each run to the subject surface ####
#for r in {1..3}
#do
	#run=run-0${r}
	#reg-feat2anat --feat ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_${run}_bold_${subj}.feat \
#--subject $subj

#done

#### resample all copes to a common surface ####

mris_preproc --target fsaverage --hemi lh \
  --out ../data/BIDS/${subj}/${ses}/func/xrun/lh.cope1.mgh \
 --iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-01_bold_${subj}.feat/stats/cope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-01_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat \
   --iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-02_bold_${subj}.feat/stats/cope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-02_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat \
    --iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-03_bold_${subj}.feat/stats/cope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-03_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat 

 #mris_preproc --target fsaverage --hemi rh --fwhm 8 \
 # --out ../data/BIDS/${subj}/${ses}/func/xrun/rh.cope1.mgh \
  #--iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-01_bold_${subj}.feat/stats/cope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-01_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat \
  # --iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-02_bold_${subj}.feat/stats/cope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-02_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat \
   # --iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-03_bold_${subj}.feat/stats/cope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-03_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat 

#### resample all varcopes to a common surface ####
#mris_preproc --target fsaverage --hemi lh --fwhm 8 \
  #--out ../data/BIDS/${subj}/${ses}/func/xrun/lh.varcope1.mgh \
  #--iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-01_bold_${subj}.feat/stats/varcope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-01_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat \
   #--iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-02_bold_${subj}.feat/stats/varcope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-02_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat \
   # --iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-03_bold_${subj}.feat/stats/varcope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-03_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat 

 #mris_preproc --target fsaverage --hemi rh --fwhm 8 \
  #--out ../data/BIDS/${subj}/${ses}/func/xrun/rh.varcope1.mgh \
  #--iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-01_bold_${subj}.feat/stats/varcope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-01_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat \
  # --iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-02_bold_${subj}.feat/stats/varcope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-02_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat \
    #--iv ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-03_bold_${subj}.feat/stats/varcope1.nii.gz ../data/BIDS/${subj}/${ses}/func/${subj}_${ses}_task-relmatch_run-03_bold_${subj}.feat/reg/freesurfer/anat2exf.register.dat 

#### Surface based group analysis #### 

## 1. across runs (fixed effects)
#mri_glmfit --y ../data/BIDS/${subj}/${ses}/func/xrun/lh.cope1.mgh --yffxvar ../data/BIDS/${subj}/${ses}/func/xrun/lh.varcope1.mgh --ffxdof 133 \
           #--osgm --glmdir ../data/BIDS/${subj}/${ses}/func/xrun/lh.osgm.ffx --surf fsaverage lh \
           #--label $SUBJECTS_DIR/fsaverage/label/lh.cortex.label

#mri_glmfit --y ../data/BIDS/${subj}/${ses}/func/xrun/rh.cope1.mgh --yffxvar ../data/BIDS/${subj}/${ses}/func/xrun/rh.varcope1.mgh --ffxdof 133 \
           #--osgm --glmdir ../data/BIDS/${subj}/${ses}/func/xrun/rh.osgm.ffx --surf fsaverage rh \
           #--label $SUBJECTS_DIR/fsaverage/label/rh.cortex.label


## 2. across the group (random effects)
# a. all copes 
# concatinate all images 
#cp ../data/BIDS/${subj}/${ses}/func/xrun/lh.cope1.mgh ../data/BIDS/group_GLM/lh.cope1_${subj}.mgh
#cp ../data/BIDS/${subj}/${ses}/func/xrun/rh.cope1.mgh ../data/BIDS/group_GLM/rh.cope1_${subj}.mgh
# b. 
done
# concatinate copes
#mri_concat ../data/BIDS/group_GLM/lh*.mgh --o ../data/BIDS/group_GLM/lh.cope1_all.mgh
#mri_concat ../data/BIDS/group_GLM/rh*.mgh --o ../data/BIDS/group_GLM/rh.cope1_all.mgh

# Run glm 

#mri_glmfit --y ../data/BIDS/group_GLM/lh.cope1_all.mgh \
          # --osgm --glmdir lh.osgm.rfx --surf fsaverage lh \
          # --label $SUBJECTS_DIR/fsaverage/label/lh.cortex.label

#mri_glmfit --y ../data/BIDS/group_GLM/rh.cope1_all.mgh \
          # --osgm --glmdir rh.osgm.rfx --surf fsaverage rh \
          # --label $SUBJECTS_DIR/fsaverage/label/rh.cortex.label


#tksurfer fsaverage lh inflated \
#-overlay xrun/lh.osgm.ffx/osgm/sig.mgh \
#-thresh 2 -fmid 3 -fslope 1 
