import os
import sys
from pathlib import Path
sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *


rule multiqc:
    input:
        mqc_dir = os.path.join(BASE_DIR, "results")
    output:
        mq_report = report(
                "results/multiqc/multiqc_report.html",
                caption="..report/multiqc.rst",
                category="Quality control"
        ),
        mq_data_dir = directory(os.path.join(BASE_DIR, "results"))
    params:
        mq_dir=os.path.join(BASE_DIR, "results", "multiqc")
    shell:
        """
        mkdir {input.mqc_dir}
        multiqc --force --filename "multiqc_report.html" --outdir {params.mq_dir} {input.mqc_dir}
        """