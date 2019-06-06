package cluster

import (
	"fmt"
	"log"
	"os"
	"os/exec"

	"bufio"
	"github.com/kubernauts/tk8/pkg/common"
	"github.com/kubernauts/tk8/pkg/provisioner"
	"github.com/kubernauts/tk8/pkg/templates"
	"github.com/spf13/viper"
)

type cattleAWSDistOS struct {
	User     string
	AmiOwner string
	NodeOS   string
}

// DistOSMap holds the main OS distribution mapping information.
var cattleAWSDistOSMap = map[string]cattleAWSDistOS{
	"centos": cattleAWSDistOS{
		User:     "centos",
		AmiOwner: "688023202711",
		NodeOS:   "dcos-centos7-*",
	},
	"ubuntu": cattleAWSDistOS{
		User:     "ubuntu",
		AmiOwner: "099720109477",
		NodeOS:   "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-*",
	},
	"coreos": cattleAWSDistOS{
		User:     "core",
		AmiOwner: "595879546273",
		NodeOS:   "CoreOS-stable-*",
	},
}

func cattleAWSDistSelect() (string, string) {
	//Read Configuration File
	AmiID, InstanceOS, sshUser := cattleAWSGetDistConfig()

	if AmiID != "" && sshUser == "" {
		log.Fatal("SSH Username is required when using custom AMI")
		return "", ""
	}
	if AmiID == "" && InstanceOS == "" {
		log.Fatal("Provide either of AMI ID or OS in the config file.")
		return "", ""
	}

	if AmiID != "" && sshUser != "" {
		InstanceOS = "custom"
		cattleAWSDistOSMap["custom"] = cattleAWSDistOS{
			User:     sshUser,
			AmiOwner: AmiID,
			NodeOS:   "custom",
		}
	}

	return cattleAWSDistOSMap[InstanceOS].User, InstanceOS
}

// GetDistConfig is used to get config details specific to a particular distribution.
// Used to determine various details such as the SSH user about the distribution.
func cattleAWSGetDistConfig() (string, string, string) {
	ReadViperConfigFile("config")
	awsAmiID := viper.GetString("cattle-aws.ami_id")
	awsInstanceOS := viper.GetString("cattle-aws.os")
	sshUser := viper.GetString("cattle-aws.ssh_user")
	return awsAmiID, awsInstanceOS, sshUser
}

func cattleAWSPrepareConfigFiles(InstanceOS string, Name string) {
	fmt.Println(InstanceOS)
	templates.ParseTemplate(templates.VariablesCattleAWS, "./inventory/"+common.Name+"/provisioner/variables.tf", GetCattleAWSConfig())
	templates.ParseTemplate(templates.DistVariablesCattleAWS, "./inventory/"+common.Name+"/provisioner/modules/cattle-aws/distos.tf", cattleAWSDistOSMap[InstanceOS])
}

// Install is used to setup the Kubernetes Cluster with RKE
func Install() {
	os.MkdirAll("./inventory/"+common.Name+"/provisioner/modules/cattle-aws", 0755)
	exec.Command("cp", "-rfp", "./provisioner/cattle-aws/", "./inventory/"+common.Name+"/provisioner").Run()
	cattleAWSSSHUser, cattleAWSOSLabel := cattleAWSDistSelect()
	fmt.Printf("Prepairing Setup for user %s on %s\n", cattleAWSSSHUser, cattleAWSOSLabel)
	cattleAWSPrepareConfigFiles(cattleAWSOSLabel, common.Name)
	// Check if a terraform state file already exists
	if _, err := os.Stat("./inventory/" + common.Name + "/provisioner/terraform.tfstate"); err == nil {
		log.Fatal("There is an existing cluster, please remove terraform.tfstate file or delete the installation before proceeding")
	} else {
		log.Println("starting terraform init")

		provisioner.ExecuteTerraform("init", "./inventory/"+common.Name+"/provisioner/")

	}

	terrSet := exec.Command("terraform", "apply", "-auto-approve")
	terrSet.Dir = "./inventory/" + common.Name + "/provisioner/"
	stdout, err := terrSet.StdoutPipe()
	if err != nil {
		log.Fatal(err)
	}
	scanner := bufio.NewScanner(stdout)
	go func() {
		for scanner.Scan() {
			fmt.Println(scanner.Text())
		}
	}()
	if err := terrSet.Start(); err != nil {
		log.Fatal(err)
	}
	if err := terrSet.Wait(); err != nil {
		log.Fatal(err)
	}

	//provisioner.ExecuteTerraform("apply", "./inventory/"+common.Name+"/provisioner/")

	log.Println("Voila! Kubernetes cluster is provisioned in Rancher. Please check the further details about the cluster in Rancher GUI")

	os.Exit(0)

}

func Upgrade() {
	if _, err := os.Stat("./inventory/" + common.Name + "/provisioner/terraform.tfstate"); err == nil {
		if os.IsNotExist(err) {
			log.Fatal("No terraform.tfstate file found. Upgrade can only be done on an existing cluster.")
		}
	}
	log.Println("Starting Upgrade of the existing cluster")
	terrSet := exec.Command("terraform", "apply", "-auto-approve")
	terrSet.Dir = "./inventory/" + common.Name + "/provisioner/"
	stdout, err := terrSet.StdoutPipe()
	if err != nil {
		log.Fatal(err)
	}
	scanner := bufio.NewScanner(stdout)
	go func() {
		for scanner.Scan() {
			fmt.Println(scanner.Text())
		}
	}()
	if err := terrSet.Start(); err != nil {
		log.Fatal(err)
	}
	if err := terrSet.Wait(); err != nil {
		log.Fatal(err)
	}
}

// Reset is used to reset the  Kubernetes Cluster back to rollout on the infrastructure.
func Reset() {
	provisioner.NotImplemented()
}

// Remove is used to remove the Kubernetes Cluster from the infrastructure
// func Remove() {
// 	log.Println("Removing cattle-aws cluster")
// 	rkeConfig := "./inventory/" + common.Name + "/provisioner/rancher-cluster.yml"
// 	rkeRemove := exec.Command("cattle-aws", "remove", "--config", rkeConfig)
// 	stdout, err := rkeRemove.StdoutPipe()
// 	rkeRemove.Stderr = rkeRemove.Stdout
// 	rkeRemove.Start()
//
// 	scanner := bufio.NewScanner(stdout)
// 	for scanner.Scan() {
// 		m := scanner.Text()
// 		fmt.Println(m)
// 	}
//
// 	rkeRemove.Wait()
// 	if err != nil {
// 		panic(err)
// 	}
// 	log.Println("Successfully removed cattle-aws cluster")
// }

func Destroy() {
	log.Println("starting terraform destroy")
	provisioner.ExecuteTerraform("destroy", "./inventory/"+common.Name+"/provisioner/")
}
