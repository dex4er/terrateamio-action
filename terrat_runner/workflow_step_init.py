import logging
import os

import cmd
import repo_config
import workflow_step_terraform


def run(state, config):
    original_config = config
    config = original_config.copy()
    config['args'] = ['init']
    config['output_key'] = 'init'

    (failed, state) = workflow_step_terraform.run(state, config)
    if failed:
        return (failed, state)

    create_and_select_workspace = repo_config.get_create_and_select_workspace(state.repo_config,
                                                                              state.path)

    logging.info('WORKFLOW_STEP_INIT : CREATE_AND_SELECT_WORKSPACE : %s : %r',
                 state.path,
                 create_and_select_workspace)

    if create_and_select_workspace:
        terraform_version = state.workflow['terraform_version']

        terraform_cmd = os.path.join('/usr', 'local', 'tf', 'versions', terraform_version, 'terraform')
        config = original_config.copy()
        config['cmd'] = [terraform_cmd, 'workspace', 'select', state.workspace]
        proc = cmd.run(state, config)

        if proc.returncode != 0:
            # TODO: Is this safe?!
            config['cmd'] = [terraform_cmd, 'workspace', 'new', state.workspace]
            proc = cmd.run(state, config)

            return (proc.returncode != 0, state)

    return (False, state)
