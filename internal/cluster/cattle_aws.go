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
)

func cattleAWSPrepareConfigFiles(Name string) {
	if ConfigType == "noTemplate" {
		templates.ParseTemplate(templates.VariablesCattleAWS, "./inventory/"+common.Name+"/provisioner/variables.tf", GetCattleAWSConfig())
	} else {
		templates.ParseTemplate(templates.VariablesCattleAWSTemplate, "./inventory/"+common.Name+"/provisioner/variables.tf", GetCattleAwsConfigTemplate())
	}
}

// Install is used to setup the Kubernetes Cluster with RKE
func Install() {

	err := common.CopyDir("./provisioner/cattle-aws", "./inventory/"+common.Name+"/provisioner")

	if err != nil {
		fmt.Printf("The copy operation failed %q\n", err)
	}

	//cattleAWSSSHUser, cattleAWSOSLabel := cattleAWSDistSelect()
	//fmt.Printf("Prepairing Setup for user %s on %s\n", cattleAWSSSHUser, cattleAWSOSLabel)
	cattleAWSPrepareConfigFiles(common.Name)
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

	cattleAWSPrepareConfigFiles(common.Name)
	
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

func CattleDestroy() {
	log.Println("starting terraform destroy")
	//provisioner.ExecuteTerraform("destroy", "./inventory/"+common.Name+"/provisioner/")
	terrSet := exec.Command("terraform", "destroy", "-auto-approve")
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
