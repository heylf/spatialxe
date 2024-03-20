//
// Perform preprocessing steps for the selected segmentation methods
//

include { PREPROCESSING } from '../../modules/local/preprocessing'

workflow SEG_PREPROCESSING {
    take:
    path(transcripts_csv)

    main:
    PREPROCESSING ( "${input}/transcripts.csv.gz" )

    emit:
    filtered_transcripts
}

