__author__ = "Pierre-Edouard Guerin"
__license__ = "MIT"


## decompress file
rule fastqgz_gunzip:
	input:
		config["fastqFolderPath"]+"/{run}.fastq.gz"
	output:
		temp("02-fastq/{run}.fastq")
	log:
		"10-logs/fastqgz_gunzip/{run}.log"
	shell:
		'''zcat {input} > {output} 2> {log}'''

## Keep reads that were filtered.
rule fastq_illumina_filter:
	input:
		"02-fastq/{run}.fastq"
	output:
		"03-illumina_filter/{run}.i.fastq"
	singularity:
		config["container"]
	log:
		"10-logs/fastq_illumina_filter/{run}.log"
	shell:
		'''fastq_illumina_filter --keep N -o {output} {input} 2> {log}'''

## remove adapters, phiX and contaminants
rule phix_filter:
	input:
		"03-illumina_filter/{run}.i.fastq"
	output:
		"04-phix_filter/{run}.i.p.fastq"
	singularity:
		config["container"]
	log:
		"10-logs/phix_filter/{run}.log"
	shell:
		'''bbduk.sh in={input} out={output} k=31 ref=artifacts,phix ordered cardinality 2> {log}'''

## quality trimming, length filtering, polyG tail trimming
rule quality_filter:
	input:
		"04-phix_filter/{run}.i.p.fastq"
	output:
		"05-trimmed/{run}.i.p.q.fastq.gz"
	singularity:
		config["container"]
	threads:
		config["threads_by_job"]
	params:
		n_base_limit=config["fastp"]["n_base_limit"],
		qualified_quality_phred=config["fastp"]["qualified_quality_phred"],
		unqualified_percent_limit=config["fastp"]["unqualified_percent_limit"],
		length_required=config["fastp"]["length_required"],
		cut_tail_window_size=config["fastp"]["cut_tail_window_size"],
		cut_tail_mean_quality=config["fastp"]["cut_tail_mean_quality"],
		poly_g_min_len=config["fastp"]["poly_g_min_len"]
	log:
		err="10-logs/quality_filter/{run}.log",
		html="10-logs/quality_filter/{run}.html",
		json="10-logs/quality_filter/{run}.json"
	shell:
		'''fastp -i {input} -o {output} --thread {threads} --n_base_limit {params.n_base_limit} \
		--qualified_quality_phred {params.qualified_quality_phred} --unqualified_percent_limit {params.unqualified_percent_limit} \
		--length_required {params.length_required} --cut_tail --cut_tail_window_size {params.cut_tail_window_size} --cut_tail_mean_quality {params.cut_tail_mean_quality} \
		--trim_poly_g --poly_g_min_len {params.poly_g_min_len} \
		--json {log.json} --html {log.html} 2> {log.err}'''