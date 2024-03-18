process PREPROCESSING {
    tag "$meta.id"
    label 'process_medium'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'vpetukhov/baysor:v0.5.0': '' }"

    input:
    path(xenium_bundle)

    output:
    path "${meta.id}_filtered_transcripts.csv"
    path  "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    
    filter_transcripts.py -transcript "${xenium_bundle}/transcripts.csv.gz"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        baysor: \$( baysor --version | sed -e "s/baysor v//g" )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch "${prefix}_filtered_transcripts.csv"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        baysor: \$( baysor --version | sed -e "s/baysor v//g" )
    END_VERSIONS
    """
}
