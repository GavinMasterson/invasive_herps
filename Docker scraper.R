docker -v. ~.Downloads
# or some version of this command line 

# IMPORTANT: initiate the docker instance in terminal IN THE FOLDER that you want to receive the export in. 

#For example in a workflow:

WORK_DIR <- getwd()

# Open terminal 
#cd WORK_DIR

# then docker run -v. ~.Downloads ... or whatever