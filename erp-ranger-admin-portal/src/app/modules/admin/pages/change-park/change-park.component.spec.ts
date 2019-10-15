import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangeParkComponent } from './change-park.component';

describe('ChangeParkComponent', () => {
  let component: ChangeParkComponent;
  let fixture: ComponentFixture<ChangeParkComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChangeParkComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangeParkComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
