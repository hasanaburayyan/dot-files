package cmd

import (
	"fmt"
	"github.com/hasanaburayyan/dev-env/installer/v2/lib"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"log"
	"os"
)

var (
	cfgFile        string
	installDir     string
	rcFile         string
	verbose        bool
	dry            bool
	uninstall      bool
	forceDownload  bool
	displayVersion bool
	Version        = "development"
	ctx            lib.InstallContext
)

var rootCmd = &cobra.Command{
	Use:   "installer",
	Short: "Easy installer for dot file",
	Long:  "Easy installer for dot files",
	Run: func(cmd *cobra.Command, args []string) {
		processCommand(cmd, args)
	},
}

func processCommand(cmd *cobra.Command, args []string) {
	if displayVersion {
		fmt.Println("Version:\t", Version)
		os.Exit(0)
	}

	if verbose {
		log.Println("Verbose mode on!")
	}

	if dry {
		log.Println("Dry run mode on!")
	}

	ctx := lib.NewInstallContext("https://github.com/hasanaburayyan/dot-files.git")

	if rcFileFlag := cmd.Flag("rc-file").Value.String(); rcFileFlag != "" {
		ctx.SetRcFile(rcFileFlag)
	}

	if installDirFlag := cmd.Flag("install-dir").Value.String(); installDirFlag != "" {
		ctx.SetInstallDir(installDirFlag)
	}

	if forceDownload {
		ctx.SetForceDownload()
	}

	log.Println(ctx)

	installer := lib.NewInstaller(*ctx)

	if uninstall {
		installer.Uninstall()
	} else {
		installer.Install()
	}
}

func init() {
	cobra.OnInitialize(initConfig)
	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "Enable verbose mode")
	rootCmd.PersistentFlags().BoolVarP(&dry, "dry", "d", false, "Enable dry run mode (also enables verbose)")
	rootCmd.PersistentFlags().BoolVarP(&uninstall, "uninstall", "u", false, "Toggle uninstall")
	rootCmd.PersistentFlags().BoolVar(&displayVersion, "version", false, "Display version details")
	rootCmd.PersistentFlags().BoolVarP(&forceDownload, "force-download", "f", false, "Forces new download of dot files")
	rootCmd.PersistentFlags().StringVarP(&rcFile, "rc-file", "r", "", "rc file to use for installing source commands (Must be absolute path)")
	rootCmd.PersistentFlags().StringVarP(&installDir, "install-dir", "x", "", "The directory to download dot-files")

}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatalln(err)
	}
}

func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := os.UserHomeDir()
		cobra.CheckErr(err)

		// Search config in home directory with name ".cobra" (without extension).
		viper.AddConfigPath(home)
		viper.SetConfigType("yaml")
		viper.SetConfigName(".cobra")
	}

	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	}
}
