/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('shows metrics', () => {
  cy.visit('/');
  cy.fixture('metric_name').then((m) => {
    cy.contains(m.name);
  });
});

it('shows memberlist', () => {
  cy.visit('/memberlist')
  cy.fixture('components').then((comps) => {
    comps.components.forEach((comp) => {
      cy.contains(comp);
    });
  });
});
