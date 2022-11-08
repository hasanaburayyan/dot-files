package lib

import (
	"fmt"
	"log"
	"os"
)

var (
	defaultSignature = "managed by dot_file installer please dont remove"
)

type InstallContext struct {
	GithubURL        string
	InstallDirectory string
	RcFile           string
	InstallLines     []string
	InstallSignature string
	ForceDownload    bool
}

func (i *InstallContext) generateInstallLines() {
	i.InstallLines = append(
		i.InstallLines,
		fmt.Sprintf("source %s/.sources", i.InstallDirectory),
		fmt.Sprintf("export MY_DOT_FILE_DIR='%s'", i.InstallDirectory),
	)
}

func (i *InstallContext) SetForceDownload() {
	i.ForceDownload = true
}

func (i *InstallContext) SetInstallDir(installDir string) {
	i.InstallDirectory = fmt.Sprintf("%s/dot-files", installDir)
}

func (i *InstallContext) SetRcFile(rcFile string) {
	i.RcFile = rcFile
}

func NewInstallContext(githubURL string) *InstallContext {
	userHomeDir, err := os.UserHomeDir()
	if err != nil {
		log.Fatalln("Could not determine user home directory... please rerun with --install-dir arg")
	}

	rcFile := fmt.Sprintf("%s/.bashrc", userHomeDir)
	installDir := fmt.Sprintf("%s/.dot_installer", userHomeDir)

	ctx := InstallContext{
		GithubURL:        githubURL,
		InstallSignature: defaultSignature,
	}

	ctx.SetRcFile(rcFile)
	ctx.SetInstallDir(installDir)
	ctx.generateInstallLines()

	return &ctx
}
