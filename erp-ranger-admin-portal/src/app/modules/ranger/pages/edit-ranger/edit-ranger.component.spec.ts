import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EditRangerComponent } from './edit-ranger.component';

describe('EditRangerComponent', () => {
  let component: EditRangerComponent;
  let fixture: ComponentFixture<EditRangerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EditRangerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EditRangerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
