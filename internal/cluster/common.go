package cluster

import (
	"log"

	"github.com/kubernauts/tk8/pkg/common"
	"github.com/spf13/viper"
)

type AwsCredentials struct {
	AwsAccessKeyID   string
	AwsSecretKey     string
	AwsAccessSSHKey  string
	AwsDefaultRegion string
}

type CattleAWSConfig struct {
	RancherClusterName       string
	RancherAPIURL            string
	RancherAccessKey         string
	RancherSecretKey         string
	RKENetworkPlugin         string
	Region                   string
	ExistingVPC              bool
	VPCID                    string
	SubnetID                 string
	SecurityGroupName        string
	OS                       string
	WorkerInstanceType       string
	OverlapCpEtcdWorker      bool
	OverlapHostnamePrefix    string
	OverlapQuantity          string
	MasterHostnamePrefix     string
	MasterQuantity           string
	WorkerHostnamePrefix     string
	WorkerQuantity           string
	IAMInstanceProfile       string
	IAMInstanceProfileWorker string
	RootDiskSize             string
	RequestSpotInstances     bool
	SpotPrice                string
	ControlPlaneInstanceType string
	AmiID                    string
	CloudwatchMonitoring     bool
	SshUser                  string
	Zone                     string
	VpcCidrBlock             string
}

func GetCattleAWSConfig() CattleAWSConfig {
	ReadViperConfigFile("config")
	return CattleAWSConfig{
		RancherClusterName:       viper.GetString("cattle-aws.rancher_cluster_name"),
		RancherAPIURL:            viper.GetString("cattle-aws.rancher_api_url"),
		RancherAccessKey:         viper.GetString("cattle-aws.rancher_access_key"),
		RancherSecretKey:         viper.GetString("cattle-aws.rancher_secret_key"),
		RKENetworkPlugin:         viper.GetString("cattle-aws.rke_network_plugin"),
		Region:                   viper.GetString("cattle-aws.region"),
		ExistingVPC:              viper.GetBool("cattle-aws.existing_vpc"),
		VPCID:                    viper.GetString("cattle-aws.vpc_id"),
		SubnetID:                 viper.GetString("cattle-aws.subnet_id"),
		SecurityGroupName:        viper.GetString("cattle-aws.security_group_name"),
		OS:                       viper.GetString("cattle-aws.os"),
		WorkerInstanceType:       viper.GetString("cattle-aws.worker_instance_type"),
		OverlapCpEtcdWorker:      viper.GetBool("cattle-aws.overlap_cp_etcd_worker"),
		OverlapHostnamePrefix:    viper.GetString("cattle-aws.overlap_node_pool.hostname_prefix"),
		OverlapQuantity:          viper.GetString("cattle-aws.overlap_node_pool.quantity"),
		MasterHostnamePrefix:     viper.GetString("cattle-aws.master_node_pool.hostname_prefix"),
		MasterQuantity:           viper.GetString("cattle-aws.master_node_pool.quantity"),
		WorkerHostnamePrefix:     viper.GetString("cattle-aws.worker_node_pool.hostname_prefix"),
		WorkerQuantity:           viper.GetString("cattle-aws.worker_node_pool.quantity"),
		IAMInstanceProfile:       viper.GetString("cattle-aws.iam_instance_profile_name"),
		IAMInstanceProfileWorker: viper.GetString("cattle-aws.iam_instance_profile_worker"),
		RootDiskSize:             viper.GetString("cattle-aws.root_disk_size"),
		RequestSpotInstances:     viper.GetBool("cattle-aws.request_spot_instances"),
		SpotPrice:                viper.GetString("cattle-aws.spot_price"),
		ControlPlaneInstanceType: viper.GetString("cattle-aws.controlplane_instance_type"),
		AmiID:                    viper.GetString("cattle-aws.ami_id"),
		CloudwatchMonitoring:     viper.GetBool("cattle-aws.cloudwatch_monitoring"),
		SshUser:                  viper.GetString("cattle-aws.ssh_user"),
		Zone:                     viper.GetString("cattle-aws.zone"),
		VpcCidrBlock:             viper.GetString("cattle-aws.vpc_cidr_block"),
	}
}

func SetClusterName() {
	if len(common.Name) < 1 {
		config := GetCattleAWSConfig()
		common.Name = config.RancherClusterName
	}
}

// ReadViperConfigFile is define the config paths and read the configuration file.
func ReadViperConfigFile(configName string) {
	viper.SetConfigName(configName)
	viper.AddConfigPath(".")
	viper.AddConfigPath("/tk8")
	verr := viper.ReadInConfig() // Find and read the config file.
	if verr != nil {             // Handle errors reading the config file.
		log.Fatalln(verr)
	}
}
