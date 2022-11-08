package lib

import (
	"bufio"
	"fmt"
	"gopkg.in/src-d/go-git.v4"
	"log"
	"os"
	"strings"
)

type Installer struct {
	ctx InstallContext
}

func (i Installer) SearchForPreviousInstalls() (bool, error) {
	file, err := os.Open(i.ctx.RcFile)
	if err != nil {
		return false, err
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		if strings.Contains(scanner.Text(), i.ctx.InstallSignature) {
			return true, nil
		}
	}
	return false, nil
}

func (i Installer) Uninstall() {
	log.Println("Uninstalling...")

	content, err := os.ReadFile(i.ctx.RcFile)
	if err != nil {
		log.Fatalln(err)
	}
	lines := strings.Split(string(content), "\n")

	var updatedLines []string

	for _, line := range lines {
		if !strings.Contains(line, i.ctx.InstallSignature) {
			updatedLines = append(updatedLines, line)
		}
	}
	updatedContent := strings.Join(updatedLines, "\n")
	err = os.WriteFile(i.ctx.RcFile, []byte(updatedContent), 0644)
	if err != nil {
		log.Fatalln(err)
	}
}

func (i Installer) Install() {
	exits, err := i.SearchForPreviousInstalls()
	if err != nil {
		log.Fatalln(err)
	}

	if exits {
		log.Println("Installer already found installation... skipping install...")
	} else {
		log.Println("Installing...")
		i.downloadFiles()
		i.writeLines()
		log.Println("Install Complete!")
		i.summary()
	}
}

func (i Installer) summary() {
	log.Printf("InstallSummary\n")
	log.Println("===========================================================")
	log.Printf("Added the following lines to rc file: %s", i.ctx.RcFile)
	for _, line := range i.ctx.InstallLines {
		log.Printf("\t- %s", line)
	}
	log.Printf("Stored download folder at: %s", i.ctx.InstallDirectory)
}

func (i Installer) writeLines() {
	log.Printf("Writing lines to %s...\n", i.ctx.RcFile)
	file, err := os.OpenFile(i.ctx.RcFile, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0644)
	if err != nil {
		log.Fatalln(err)
	}
	defer file.Close()

	for _, line := range i.ctx.InstallLines {
		if _, err := file.WriteString(fmt.Sprintf("%s # %s\n", line, i.ctx.InstallSignature)); err != nil {
			log.Fatalln(err)
		}
	}
}

func (i Installer) downloadFiles() {
	if i.ctx.ForceDownload {
		log.Println("Forcing download of new dot files...")

		err := os.RemoveAll(i.ctx.InstallDirectory)
		if err != nil {
			log.Fatalln(err)
		}

		log.Println("Old files removed...")
	}

	if _, err := os.Stat(i.ctx.InstallDirectory); err != nil {
		log.Println("Downloading files...")
		_, err := git.PlainClone(i.ctx.InstallDirectory, false, &git.CloneOptions{
			URL:      i.ctx.GithubURL,
			Progress: os.Stdout,
		})

		if err != nil {
			log.Fatalln(err)
		}
	} else {
		log.Println("Download files already found... skipping download...")
		log.Println("To force re-download please use --force-download flag...")
	}
}

func NewInstaller(ctx InstallContext) *Installer {
	return &Installer{
		ctx: ctx,
	}
}
