gal3_spots= newArray();
savedir = "D:/A549_LLOME_GAL3_1hr_quantification/WT_image1_60min_rep1/WT_image1_60min_rep1_cell1/"
image = "image1"
replicate = "rep1"
cell = "cell1"
condition = "WT"
timepoint = "60min"

gal3_image = condition + "_" + image + "_" + timepoint + "_" + replicate + "_" + cell + "_crop_MAX_C2-A549 C2 REP2_60min LLOMe_Gal3 488_Zscan_2024-12-04_17.20.21-1.tif"

gal3_mask = condition + "_" + image + "_" + timepoint + "_" + replicate + "_" + cell + "_" + "GAL3_signal_mask"

//STEP1: SET THRESHOLDS, CREATE MASKS, SAVE MASKS, ANALYZE PARTICLES in Gal3 MASK
run("Duplicate...")
selectWindow(gal3_image);
run("Brightness/Contrast...");
setMinAndMax(3000, 8000);
run("Mean...", "radius=2");
run("Make Inverse");
run("Set...", "value=0");
run("Select None");
setAutoThreshold("Default dark no-reset");
run("Create Mask");
selectWindow("mask");
run("Watershed");
save(savedir + condition + "_" + image + "_" + timepoint + "_" + replicate + "_" + cell + "_GAL3_SIGNAL_MASK");
selectWindow("mask");
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=Nothing clear add to manager");


for (i = 0; i < roiManager("Count"); i++){
	selectWindow("mask");
	roiManager("Select", i);
	getStatistics(area);
	print(area);
	if (area > 0.030){
		gal3_spots= Array.concat(gal3_spots,i);
	}
}


if (gal3_spots.length == 0) {
	roiManager("Select", gal3_spots);
	roiManager("Delete");
	file = File.open(savedir + "NO_GAL3_SPOTS.txt");
	File.close(file);
	exit();
}


if (gal3_spots.length > 0){
	roiManager("Select", gal3_spots);
	roiManager("save selected", savedir + condition + "_" + image + "_" + timepoint + "_" + replicate + "_" + cell + "_GAL3_SPOTS_RoiSet.zip");
	selectWindow(gal3_image);
	roiManager("Measure");
	selectWindow("Results");
	saveAs("Results", savedir + condition + "_" + image + "_" + timepoint + "_" + replicate + "_" + cell + "_GAL3_SPOTS_SIGNAL_Results.csv");
	close("Results");
}