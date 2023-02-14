### turn surface labels into an ROI (ie mask) in volume space. ###


SUBJECTS_LIST='/Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/subs_list2.txt'
#DATA_DIR='/Users/willav/Downloads/data/BIDS'
SUBJECTS_DIR=/Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/subjects

DATA_DIR=/Users/willav/GoogleDrive/Research/cnl-berkeley/ongoing_projects/NORA_relmatch_funcNeuroAnat/data/BIDS/derivatives/preprocessing/native_smooth_2mm

for s in `cat $SUBJECTS_LIST`
do

	session=${s: -1}
	sub=${s: 1:3}
	subj='sub-'${sub}
	ses='ses-'${session}
	functional_template=${DATA_DIR}/sub-${sub}_${ses}_run-01.feat/filtered_func_data.nii.gz

	echo $ses
	echo $subj

	#### Create a register .dat file
	bbregister --mov path/to/your/volume/file --s ${sub} --t1 --reg register.dat

	### transform label to volume 
		# temp : volume space template (use function nifti or volume space image you are projecting ROIs to)
		# fillthresh: require that a voxel be filled at least 51% by that label. 
	mri_label2vol \
	--label ${SUBJECTS_DIR}/${subj}/label/rh.pmfs_i.label \
	--label ${SUBJECTS_DIR}/${subj}/label/rh.pmfs_a.label \
	--label ${SUBJECTS_DIR}/${subj}/label/rh.painfs.label \
	--temp ${functional_template} \
	--reg ${DATA_DIR}/sub-${sub}_${ses}_run-01.feat/reg/freesurfer/register.dat \
	--fillthresh .51 \
	--o ${DATA_DIR}/sub-${sub}_${ses}_run-01.feat/mask_pmfs_sulci.nii.gz \

done


