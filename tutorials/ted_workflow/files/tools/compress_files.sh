#!/bin/bash
tar -czv --exclude='.DS_Store' -f TED_workflow.tar.gz data headers modules posterior_summary
