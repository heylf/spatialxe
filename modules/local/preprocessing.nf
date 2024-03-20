process PREPROCESSING {
    tag "$meta.id"
    label 'process_medium'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'vpetukhov/baysor:v0.5.0': '' }"

    input:
    path(transcripts_csv)

    output:
    path (filtered_transcripts), emit: filtered_transcripts
    path  "versions.yml"       , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    filter_transcripts.py -transcript "${transcripts_csv}"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        filter_transcripts.py: \$( filter_transcripts.py -version)
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch "${filtered_transcripts}"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        filter_transcripts.py: \$( filter_transcripts.py -version)
    END_VERSIONS
    """
}
