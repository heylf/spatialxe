process PREPROCESSING {
    tag "$meta.id"
    label 'process_medium'

    container "docker.io/vpetukhov/baysor:v0.6.2
"

    input:
    path(transcripts_csv)

    output:
    path (filtered_transcripts), emit: filtered_transcripts
    path  "versions.yml"       , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error "Preprocessing module does not support Conda. Please use Docker / Singularity / Podman instead."
    }
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
    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error "Preprocessing module does not support Conda. Please use Docker / Singularity / Podman instead."
    }
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch "${filtered_transcripts}"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        filter_transcripts.py: \$( filter_transcripts.py -version)
    END_VERSIONS
    """
}
