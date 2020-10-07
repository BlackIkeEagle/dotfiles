#!/usr/bin/env bash

#######################################
# BlackEagle's vcs-status for tmux    #
#######################################

SCMDIRTY=1

# front colors
COLRED='#[fg=#cc342b]'
COLGRN='#[fg=#198844]'
COLYLW='#[fg=#fba922]'
COLBLU='#[fg=#3971ed]'
COLCYN='#[fg=#39d3ed]'

# border color
PSCOL='#[fg=#3971ed]'

function vcsstatus {
    local active=$1

    if [[ $active -ne 1 ]]; then
        return;
    fi

    if [[ $(id -u) == "0" ]]; then
        return;
    fi

    GITENABLED=0
    HGENABLED=0
    SVNENABLED=0
    BZRENABLED=0
    if which git > /dev/null 2>&1; then
        GITENABLED=1
    fi
    if which hg > /dev/null 2>&1; then
        HGENABLED=1
    fi
    if which svn > /dev/null 2>&1; then
        SVNENABLED=1
    fi
    if which bzr > /dev/null 2>&1; then
        BZRENABLED=1
    fi

    if [[ $GITENABLED -eq 1 ]] && GITBRANCH=$(git rev-parse --abbrev-ref HEAD 2>&1); then
        GITDIRTY=
        if [[ $SCMDIRTY -eq 1 ]]; then
            # if has unstaged changes
            git diff --no-ext-diff --quiet --exit-code || GITDIRTY=" *"
            # if it has staged changes
            if [[ "$GITDIRTY" = "" ]]; then
                git diff --staged --no-ext-diff --quiet --exit-code || GITDIRTY=" +"
            fi
        fi
        if [[ "${GITBRANCH}" == "master" ]] || [[ "${GITBRANCH}" == "main" ]]; then
            GITBRANCH="${PSCOL}─(${COLYLW}git${PSCOL})─(${COLGRN}${GITBRANCH}${GITDIRTY}${PSCOL})"
        elif [[ "${GITBRANCH}" == "" ]]; then
            GITBRANCH="${PSCOL}─(${COLYLW}git${PSCOL})─(${COLRED}$(git rev-parse --short HEAD)...${GITDIRTY}${PSCOL})"
        else
            GITBRANCH="${PSCOL}─(${COLYLW}git${PSCOL})─(${COLCYN}${GITBRANCH}${GITDIRTY}${PSCOL})"
        fi
        printf "%s" "${GITBRANCH}"
    elif [[ $HGENABLED -eq 1 ]] && HGBRANCH=$(hg branch 2>/dev/null); then
        HGDIRTY=
        if [[ $SCMDIRTY -eq 1 ]]; then
            [[ "$(hg status -n | wc -l)" == "0" ]] || HGDIRTY=" *"
        fi
        if [[ "${HGBRANCH}" == "default" ]]; then
            HGBRANCH="${PSCOL}─(${COLYLW}hg${PSCOL})─(${COLGRN}${HGBRANCH}${HGDIRTY}${PSCOL})"
        else
            HGBRANCH="${PSCOL}─(${COLYLW}hg${PSCOL})─(${COLRED}${HGBRANCH}${HGDIRTY}${PSCOL})"
        fi
        printf "%s" "${HGBRANCH}"
    elif [[ $SVNENABLED -eq 1 ]] && SVNINFO=$(svn info 2>&1); then
        SVNREVISION=$(echo "$SVNINFO" | sed -ne 's/^Revision: //p')
        if [[ $SCMDIRTY -eq 1 ]]; then
            [[ "$(svn status | wc -l)" == "0" ]] || SVNDIRTY=" *"
        fi
        SVNBRANCH="${PSCOL}─(${COLYLW}svn${PSCOL})─(${COLGRN}${SVNREVISION}${SVNDIRTY}${PSCOL})"
        printf "%s" "${SVNBRANCH}"
    elif [[ $BZRENABLED -eq 1 ]] && bzr nick > /dev/null 2>&1; then
        BZRREVISION=$(bzr revno)
        if [[ $SCMDIRTY -eq 1 ]]; then
            [[ "$(bzr status | wc -l)" == "0" ]] || BZRDIRTY=" *"
        fi
        BZRBRANCH="${PSCOL}─(${COLYLW}bzr${PSCOL})─(${COLGRN}${BZRREVISION}${BZRDIRTY}${PSCOL})"
        printf "%s" "${BZRBRANCH}"
    fi
}

(
    cd "$1" || exit 1
    vcsstatus "$2"
)
