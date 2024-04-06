import os
import sys
from pathlib import Path

sys.path.insert(0, Path(workflow.basedir).parent.parent.as_posix())
from constants.common import *


configfile: "config/config.yaml"


rule download:
    output:
        reads_out=expand(DATA_DIR + "/{file_name}", file_name=SAMPLES),
        ref_out=expand(REF_DIR + "/{file_name}", file_name=REF),
    shell:
        "workflow/scripts/download.sh"
