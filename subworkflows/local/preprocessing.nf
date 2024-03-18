//
// Perform preprocessing steps for the selected segmentation methods
//

include { PREPROCESSING } from '../../modules/local/preprocessing'

workflow SEG_PREPROCESSING {
    take:
    xenium_bundle // file: /path/to/xenium-bundle

    main:
    PREPROCESSING ( xenium_bundle )

    emit:
    filtered_transcripts
}

