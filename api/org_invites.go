package api

import (
	"context"

	"github.com/manifoldco/torus-cli/identity"
	"github.com/manifoldco/torus-cli/registry"
)

// OrgInvitesClient makes requests to the registry's and daemon's org invites
// endpoints
type OrgInvitesClient struct {
	*registry.OrgInvitesClient
	client *apiRoundTripper
}

func newOrgInvitesClient(upstream *registry.OrgInvitesClient, rt *apiRoundTripper) *OrgInvitesClient {
	return &OrgInvitesClient{upstream, rt}
}

// Approve executes the approve invite request
func (i *OrgInvitesClient) Approve(ctx context.Context, inviteID identity.ID, output ProgressFunc) error {
	return i.client.DaemonRoundTrip(ctx, "POST", "/org-invites/"+inviteID.String()+"/approve", nil, nil, nil, output)
}
