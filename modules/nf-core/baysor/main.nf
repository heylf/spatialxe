process BAYSOR {
    tag "$meta.id"
    label 'process_high'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'vpetukhov/baysor:v0.5.0': '' }"

    input:
    path(filtered_transcript)

    output:
    path("baysor_segmentation.csv"), emit: baysor_segmentation
    path("baysor_mtx")             , emit: baysor_mtx
    path("feature_matrix")         , emit: feature_matrix
    path  "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def PRIOR_CONF = PRIOR_CONF ? "--prior-segmentation-confidence ${PRIOR_CONF}" : ''
    def MIN_TRANSCRIPT = MIN_TRANSCRIPT ? "${MIN_TRANSCRIPT}" : ''
    """
    // perform segmentation
    Baysor run -x x_location \\
               -y y_location \\
               -z z_location \\
               -g feature_name \\
               -m ${MIN_TRANSCRIPT} \\
               -p \\
               ${PRIOR_CONF} \\
               ${TRANSCRIPT_CSV} :cell_id

    // run map transcripts
    map_transcripts.py -baysor ${baysor_segmentation} -out ${baysor_mxt}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        baysor: \$( baysor --version | sed -e "s/baysor v//g" )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch "baysor_segmentation.csv"
    touch "baysor_mtx"
    touch "feature_matrix"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        baysor: \$( baysor --version | sed -e "s/baysor v//g" )
    END_VERSIONS
    """
}
